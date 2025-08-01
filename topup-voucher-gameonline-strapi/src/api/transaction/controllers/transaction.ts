'use strict';

import { factories } from '@strapi/strapi';
const midtransClient = require('midtrans-client');

export default factories.createCoreController('api::transaction.transaction', ({ strapi }) => ({
    async create(ctx) {
        try {
            const { account_games, transaction_date, cart_items } = ctx.request.body.data;
            
            if (!cart_items || cart_items.length === 0) {
                return ctx.badRequest('Cart kosong.');
            }

            // Buat transaction kosong dulu
            const transaction = await strapi.service('api::transaction.transaction').create({
                data: {
                    account_games,
                    transaction_date: new Date().toISOString(),
                },
            });

            // Buat transaction_product satu-satu
            const createdProducts = await Promise.all(
                cart_items.map(async (item) => {
                    const product = await strapi.db.query('api::product.product').findOne({
                        where: { id: item.productId },
                    });

                    if (!product) throw new Error('Produk tidak ditemukan');

                    await strapi.service('api::transaction-product.transaction-product').create({
                        data: {
                            transaction: transaction.id,
                            product: product.id,
                            quantity: item.quantity,
                            product_prices: product.product_price,
                        },
                    });

                    return { ...product, quantity: item.quantity };
                })
            );

            const grossAmount = createdProducts.reduce((sum, p) => sum + p.product_price * p.quantity, 0);

            // Buat payment
            const order_id = `INV-${Date.now()}`;
            const payment = await strapi.service('api::payment.payment').create({
                data: {
                    order_id,
                    amount: grossAmount,
                    payment_status: 'Pending',
                    transaction: transaction.id,
                },
            });

            // Buat payment history
            await strapi.service('api::payment-history.payment-history').create({
                data: {
                    new_status: 'Pending',
                    change_at: Date.now(),
                    payment: payment.id,
                },
            });

            // Kirim Snap Midtrans
            const snap = new midtransClient.Snap({
                isProduction: false,
                serverKey: process.env.MIDTRANS_SERVER_KEY,
            });

            const itemDetails = createdProducts.map(p => ({
                id: p.id,
                name: p.product_name,
                price: p.product_price,
                quantity: p.quantity,
            }));

            const parameters = {
                transaction_details: {
                    order_id,
                    gross_amount: grossAmount,
                },
                item_details: itemDetails,
            };

            const midtransResponse = await snap.createTransaction(parameters);

            return ctx.send(midtransResponse);

        } catch (error) {
            console.error('Error create transaction:', error);
            return ctx.internalServerError('Gagal membuat transaksi.');
        }
    }
}));

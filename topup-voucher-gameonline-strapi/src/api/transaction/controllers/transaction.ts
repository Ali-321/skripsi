/**
 * transaction controller
 */

import { factories } from '@strapi/strapi'

export default factories.createCoreController('api::transaction.transaction');
'use strict';

const midtransClient = require('midtrans-client');
const { createCoreController } = require('@strapi/strapi').factories;

module.exports = createCoreController('api::transaction.transaction', ({ strapi }) => ({
    async create(ctx) {
        try {
            const data = ctx.request.body.data;
            const userId = data.user;

            // ✅ Buat Transaction
            const transaction = await strapi.service('api::transaction.transaction').create({ data });

            // ✅ Generate order_id
            const order_id = `INV-${Date.now()}`;


            // ✅ Ambil Data User
            const transactionData = await strapi.db.query('api::transaction.transaction').findOne({
                where: { id: transaction.id },
                populate: { user: { fields: ['username', 'email', 'phone'] } }
            });


            // Ambil semua data produk sekaligus
            const productIds = data.products.map(item => item.id);
            const productDataArray = await strapi.db.query('api::product.product').findMany({
                where: { id: productIds },
                select: ['id', 'product_price', 'product_name']
            });

            // Ubah productData menjadi map untuk akses cepat berdasarkan ID
            const productDataMap = {};
            productDataArray.forEach(product => {
                productDataMap[product.id] = product;
            });

            // Proses transaksi tanpa perlu mencari ulang
            const products = await Promise.all(
                data.products.map(async (item) => {
                    const product = productDataMap[item.id]; // Akses langsung berdasarkan ID

                    if (product) { // Validasi jika produk ditemukan
                        await strapi.service('api::transaction-product.transaction-product').create({
                            data: {
                                transaction: transaction.id,
                                product: product.id,
                                quantity: item.quantity,
                                product_prices: product.product_price
                            }
                        });

                        return { ...product, quantity: item.quantity };
                    }
                })
            );


            const grossAmount = products.reduce((total, item) => total + (item.product_price * item.quantity), 0);

            // ✅ Buat Payment
            const payment = await strapi.service('api::payment.payment').create({
                data: {
                    order_id: order_id,
                    amount: grossAmount,
                    payment_status: 'Pending',
                    transaction: transaction.id,
                },
            });

            // ✅ Buat Payment History
            await strapi.service('api::payment-history.payment-history').create({
                data: {
                    new_status: 'Pending',
                    change_at: Date.now(),
                    payment: payment.id,
                },
            });

            // ✅ Kirim ke Midtrans
            const snap = new midtransClient.Snap({
                isProduction: false,
                serverKey: process.env.MIDTRANS_SERVER_KEY,
            });

            const itemDetails = products.map((product) => ({
                id: product.id,
                name: product.product_name,
                price: product.product_price,
                quantity: product.quantity,
                category: "Top-up"
            }));
            const itemDescription = products
                .map(product => `${product.quantity}x ${product.product_name} @ Rp${product.product_price.toLocaleString('id-ID')}`)
                .join("\n");  // Gunakan "\n" untuk memisahkan setiap produk dalam deskripsi


            const parameters = {
                transaction_details: {
                    order_id: order_id,
                    gross_amount: grossAmount,
                },
                customer_details: {
                    first_name: transactionData.user.username || 'Customer',
                    email: transactionData.user.email || 'default@example.com',
                    phone: transactionData.user.phone || '081234567890',
                    address: 'Alamat Default',
                },
                item_details: itemDetails,
                custom_field1: itemDescription
            };

            const midtransResponse = await snap.createTransaction(parameters);

            return ctx.send(midtransResponse);

        } catch (error) {
            console.error('❌ Error:', error);
            return ctx.send({ error: 'Terjadi kesalahan saat membuat transaksi.' }, 400);
        }
    }
}));

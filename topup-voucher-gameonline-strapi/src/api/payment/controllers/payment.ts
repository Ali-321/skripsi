/**
 * payment controller
 */

import { factories } from '@strapi/strapi';
const crypto = require('crypto');

export default factories.createCoreController('api::payment.payment', ({ strapi }) => ({

    async midtransCallback(ctx) {
        try {
            // 🛠 Validasi Data dari Midtrans
            if (!ctx.request.body || Object.keys(ctx.request.body).length === 0) {
                return ctx.badRequest('Empty request body');
            }

            const {
                order_id,
                transaction_status,
                status_code,
                gross_amount,
                signature_key,
                payment_type,
                transaction_time,
            } = ctx.request.body;

            // 🔒 Ambil Server Key dari ENV
            const serverKey = process.env.MIDTRANS_SERVER_KEY.trim();

            // 🧼 Format gross_amount menjadi angka bulat string
            const formattedGrossAmount = gross_amount;

            // 🔐 Validasi Signature dari Midtrans
            const expectedSignature = crypto
                .createHash('sha512')
                .update(order_id +
                    status_code +
                    gross_amount +
                    serverKey)
                .digest('hex');

            console.log('🧾 Signature Debug:', {
                order_id,
                status_code,
                gross_amount,
                formattedGrossAmount,
                expectedSignature,
                received: signature_key,
            });

            if (signature_key !== expectedSignature) {
                strapi.log.warn('⚠️ Invalid signature key received:', signature_key);
                return ctx.badRequest('Invalid signature key');
            }

            // 🔍 Cari Payment berdasarkan order_id
            const payment = await strapi.db.query('api::payment.payment').findOne({
                where: { order_id },
                select: ['id', 'payment_status'],
            });

            if (!payment) {
                strapi.log.warn(`⚠️ Payment not found for order_id: ${order_id}`);
                return ctx.notFound('Payment not found');
            }

            const previousStatus = payment.payment_status;

            // 📝 Tentukan status baru dari Midtrans
            let newStatus;
            switch (transaction_status) {
                case 'pending':
                    newStatus = 'Pending';
                    break;
                case 'settlement':
                case 'capture':
                    newStatus = 'Success';
                    break;
                case 'failure':
                case 'cancel':
                case 'expire':
                case 'deny':
                    newStatus = 'Failed';
                    break;
                case 'refund':
                case 'partial_refund':
                    newStatus = 'Refunded';
                    break;
                default:
                    newStatus = 'Unknown';
            }

            // ✅ Update status pembayaran
            await strapi.db.query('api::payment.payment').update({
                where: { id: payment.id },
                data: {
                    payment_status: newStatus,
                    payment_date: transaction_time,
                    payment_method: payment_type,
                },
            });

            // 📝 Catat riwayat perubahan status
            if (previousStatus !== newStatus) {
                await strapi.db.query('api::payment-history.payment-history').create({
                    data: {
                        payment: payment.id,
                        previous_status: previousStatus,
                        new_status: newStatus,
                        change_at: new Date(),
                    },
                });
            }

            console.log(
                `✅ Payment updated: ${order_id} | ${previousStatus} → ${newStatus} | Method: ${payment_type} → ${transaction_status}`
            );

            return ctx.send({
                success: true,
                message: `Payment status updated from ${previousStatus} to ${newStatus}`,
            });

        } catch (error) {
            strapi.log.error('🔴 Midtrans Callback Error:', error);
            return ctx.internalServerError('Failed to process Midtrans callback');
        }
    },

    async findByTransactionId(ctx) {
        try {
            const { transactionId } = ctx.params;

            if (!transactionId) {
                return ctx.badRequest('transactionId diperlukan');
            }

            const payment = await strapi.db.query('api::payment.payment').findOne({
                where: { transaction: transactionId },
                select: ['order_id', 'amount', 'payment_status'],
            });

            if (!payment) {
                return ctx.notFound('Data payment tidak ditemukan');
            }

            return ctx.send(payment);

        } catch (error) {
            strapi.log.error('❌ Error get payment by transaction:', error);
            return ctx.internalServerError('Terjadi kesalahan saat mengambil payment');
        }
    }

}));

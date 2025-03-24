/**
 * payment controller
 */

import { factories } from '@strapi/strapi'

export default factories.createCoreController('api::payment.payment');
const crypto = require('crypto');

module.exports = {
    async midtransCallback(ctx) {
        try {
            // 🛠 Validasi Data dari Midtrans
            if (!ctx.request.body || Object.keys(ctx.request.body).length === 0) {
                return ctx.badRequest('Empty request body');
            }

            const { order_id, transaction_status, fraud_status, gross_amount, signature_key, payment_type, transaction_time } = ctx.request.body;

            // 🔒 Pastikan Server Key Diambil dari ENV
            const serverKey = process.env.MIDTRANS_SERVER_KEY;

            // 📝 Status Code Midtrans berdasarkan transaction_status
            let statusCode;
            if (transaction_status === 'settlement') {
                statusCode = '200'; // Sukses
            } else if (transaction_status === 'pending') {
                statusCode = '201'; // Menunggu pembayaran
            } else {
                statusCode = '400'; // Gagal, cancel, expired
            }

            // 🔒 Perbaiki Signature Key Sesuai Format Midtrans
            const expectedSignature = crypto
                .createHash('sha512')
                .update(order_id + statusCode + gross_amount + serverKey)
                .digest('hex');

            console.log(`🔹 Expected Signature: ${expectedSignature}`);
            console.log(`🔹 Received Signature: ${signature_key}`);

            if (signature_key !== expectedSignature) {
                strapi.log.warn("⚠️ Invalid signature key received:", signature_key);
                return ctx.badRequest('Invalid signature key');
            }

            // 🔍 Cari Payment berdasarkan order_id
            const payment = await strapi.db.query('api::payment.payment').findOne({
                where: { order_id },
                select: ['id', 'payment_status']
            });

            if (!payment) {
                strapi.log.warn(`⚠️ Payment not found for order_id: ${order_id}`);
                return ctx.notFound('Payment not found');
            }

            // 🔍 Simpan Status Sebelumnya
            const previousStatus = payment.payment_status;

            // 📝 Menentukan Status Pembayaran Sesuai Midtrans
            let newStatus;
            switch (transaction_status) {
                case 'pending':
                    newStatus = 'Pending';
                    break;
                case 'settlement':
                case 'capture': // Kartu kredit sukses
                    newStatus = 'Success';
                    break;
                case 'cancel':
                case 'expire':
                case 'deny':
                    newStatus = 'Failed';
                    break;
                case 'refund':
                case 'partial_refund': // Jika hanya sebagian yang dikembalikan
                    newStatus = 'Refunded';
                    break;
                default:
                    newStatus = 'Unknown';
            }

            // ✅ Update Status & Payment Method
            await strapi.db.query('api::payment.payment').update({
                where: { id: payment.id },
                data: {
                    payment_status: newStatus,
                    payment_date: transaction_time,
                    payment_method: payment_type // Langsung diisi dengan nilai dari Midtrans
                },
            });

            // 📝 Catat perubahan status ke Payment History
            if (previousStatus !== newStatus) {
                await strapi.db.query('api::payment-history.payment-history').create({
                    data: {
                        payment: payment.id,
                        previous_status: previousStatus, // Status sebelum diubah
                        new_status: newStatus, // Status baru
                        change_at: new Date(), // Timestamp perubahan
                    },
                });
            }


            strapi.log.info(`✅ Payment updated: ${order_id} | ${previousStatus} → ${newStatus} | Payment Method: ${payment_type}`);

            // ✅ Beri Respons Sukses ke Midtrans
            return ctx.send({ success: true, message: `Payment status updated from ${previousStatus} to ${newStatus}, payment method set to ${payment_type}` });
        } catch (error) {
            strapi.log.error('🔴 Midtrans Callback Error:', error);
            return ctx.internalServerError('Failed to process Midtrans callback');
        }
    },
};

/**
 * payment router
 */

import { factories } from '@strapi/strapi';

export default factories.createCoreRouter('api::payment.payment');

module.exports = {
    routes: [
        {
            method: 'POST',
            path: '/midtrans-callback',
            handler: 'payment.midtransCallback',
            config: {
                policies: [],
                auth: false, // ✅ Pastikan tidak membutuhkan autentikasi agar bisa diakses oleh Midtrans
            },
        },
        {
            method: 'GET',
            path: '/payment-by-transaction/:transactionId',
            handler: 'payment.findByTransactionId',
            config: {
                auth: false, // atau true jika butuh otentikasi
            },
        },

    ],
};
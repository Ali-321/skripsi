"use strict";
/**
 * payment router
 */
Object.defineProperty(exports, "__esModule", { value: true });
const strapi_1 = require("@strapi/strapi");
exports.default = strapi_1.factories.createCoreRouter('api::payment.payment');
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

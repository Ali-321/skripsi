"use strict";
/**
 * transaction service
 */
Object.defineProperty(exports, "__esModule", { value: true });
const strapi_1 = require("@strapi/strapi");
exports.default = strapi_1.factories.createCoreService('api::transaction.transaction');
'use strict';
const { createCoreService } = require('@strapi/strapi').factories;
module.exports = createCoreService('api::transaction.transaction', ({ strapi }) => ({
    async createTransactionWithPayment(ctx, data) {
        try {
            const transaction = await strapi.service('api::transaction.transaction').create({ data });
            const payment = await strapi.service('api::payment.payment').create({
                data: {
                    amount: data.amount || 10000,
                    payment_status: 'Pending',
                    transaction: transaction.id,
                },
            });
            return { transaction, payment };
        }
        catch (error) {
            console.error('❌ Error:', error);
            ctx.throw(400, 'Terjadi kesalahan saat membuat transaksi.'); // ✅ Gunakan ctx.throw untuk error
        }
    },
}));

'use strict';

import { factories } from '@strapi/strapi';

export default factories.createCoreController('api::delete-request.delete-request', ({ strapi }) => ({
  async create(ctx) {
    const { targetTable, targetDocumentId } = ctx.request.body.data;

    if (!targetTable || !targetDocumentId) {
      return ctx.badRequest('targetTable dan targetDocumentId wajib diisi.');
    }

    const fullTargetTable = `api::${targetTable}.${targetTable}`;

    try {
      const entry = await strapi.db.query(fullTargetTable).findOne({
        where: { documentId: targetDocumentId },
      });

      if (!entry) {
        return ctx.notFound(`Data di tabel ${targetTable} dengan documentId tersebut tidak ditemukan.`);
      }

      await strapi.db.query(fullTargetTable).delete({
        where: { id: entry.id },
      });

      return { message: `Data di tabel ${targetTable} dengan documentId ${targetDocumentId} berhasil dihapus.` };
    } catch (error) {
      console.error('Error deleting data:', error);
      return ctx.internalServerError('Gagal menghapus data. Pastikan tabel valid.');
    }
  },
}));

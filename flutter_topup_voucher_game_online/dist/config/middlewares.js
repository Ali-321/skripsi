/*export default [
  'strapi::logger',
  'strapi::errors',
  'strapi::security',
  'strapi::cors',
  'strapi::poweredBy',
  'strapi::query',
  'strapi::body',
  'strapi::session',
  'strapi::favicon',
  'strapi::public',
];
*/
module.exports = [
    'strapi::errors',
    'strapi::security',
    {
        name: 'strapi::cors',
        config: {
            headers: '*',
            origin: ['*'], // Bisa diganti dengan domain Midtrans jika ingin lebih aman
            methods: ['GET', 'POST', 'PUT', 'DELETE'],
        },
    },
    'strapi::logger',
    'strapi::query',
    {
        name: 'strapi::body',
        config: {
            enabled: true,
            formLimit: '5mb', // Pastikan body bisa diterima
            jsonLimit: '5mb',
            textLimit: '5mb',
            formidable: {
                maxFileSize: 200 * 1024 * 1024, // Maksimum 200MB
            },
        },
    },
    'strapi::session',
    'strapi::favicon',
    'strapi::public',
];

// src/extensions/users-permissions/routes/custom.ts

export default [
  {
    method: 'POST',
    path: '/auth/change-password',
    handler: 'change-password.changePassword',
    config: {
      auth: true,
      policies: [],
    },
  },
];

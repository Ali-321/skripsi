export default [
    {
      method: 'POST',
      path: '/delete-requests',
      handler: 'api::delete-request.delete-request.create',
      config: {
        auth: false,
        policies: [],
        middlewares: [],
      },
    },
  ];
  
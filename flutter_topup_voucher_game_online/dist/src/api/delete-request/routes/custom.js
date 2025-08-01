"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = [
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

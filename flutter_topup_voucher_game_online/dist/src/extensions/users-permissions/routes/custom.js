"use strict";
// src/extensions/users-permissions/routes/custom.ts
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = [
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

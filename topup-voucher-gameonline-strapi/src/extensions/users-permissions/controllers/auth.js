

// src/extensions/users-permissions/controllers/change-password.ts

export default {
    async register(ctx) {
        // Log semua data request dari Flutter
        console.log("📌 Incoming Register Request:", ctx.request.body);

        const { avatar, username, email, password, phone, first_name, last_name } = ctx.request.body;

        // Validasi Input
        if (!username || !email || !password) {
            return ctx.badRequest("Username, email, and password are required.");
        }

        try {
            // Cek apakah email sudah digunakan
            const existingUser = await strapi.db.query("plugin::users-permissions.user").findOne({ where: { email } });
            if (existingUser) {
                return ctx.badRequest("Email is already taken.");
            }

            // Buat User Baru
            const newUser = await strapi.entityService.create("plugin::users-permissions.user", {
                data: {
                    username,
                    email,
                    password,
                    phone: phone || null,
                    first_name: first_name || null,
                    last_name: last_name || null,
                    avatar: avatar || null
                },
            });

            // Sanitasi Data untuk Response
            const sanitizedUser = await sanitize.contentAPI.output(newUser, strapi.getModel('plugin::users-permissions.user'));

            console.log("✅ User Created Successfully:", sanitizedUser);

            return ctx.send({ user: sanitizedUser });
        } catch (error) {
            console.error("❌ Error in Register Controller:", error);
            return ctx.badRequest("Error registering user.", { error });
        }
    },
    async changePassword(ctx) {
        const user = ctx.state.user;

        if (!user) {
            return ctx.unauthorized("You must be logged in.");
        }

        const { currentPassword, newPassword } = ctx.request.body;

        if (!currentPassword || !newPassword) {
            return ctx.badRequest("Both currentPassword and newPassword are required.");
        }

        const isValid = await strapi
            .plugin("users-permissions")
            .service("user")
            .validatePassword(currentPassword, user.password);

        if (!isValid) {
            return ctx.badRequest("Current password is incorrect.");
        }

        await strapi
            .plugin("users-permissions")
            .service("user")
            .edit(user.id, { password: newPassword });

        ctx.send({ message: "Password successfully updated." });
    },
};




/*
// path: src/api/user/controllers/change-password.ts
import { factories } from '@strapi/strapi';
import bcrypt from 'bcryptjs';

export default factories.createCoreController('plugin::users-permissions.user', ({ strapi }) => ({
    async changePassword(ctx) {
        const { id } = ctx.state.user || {};
        const { currentPassword, newPassword } = ctx.request.body;

        if (!id || !currentPassword || !newPassword) {
            return ctx.badRequest('Missing required fields');
        }

        const user = await strapi
            .plugin('users-permissions')
            .service('user')
            .fetch({ id });

        if (!user) {
            return ctx.notFound('User not found');
        }

        const passwordMatch = await bcrypt.compare(currentPassword, user.password);
        if (!passwordMatch) {
            return ctx.unauthorized('Current password is incorrect');
        }

        const hashedPassword = await bcrypt.hash(newPassword, 10);

        await strapi
            .plugin('users-permissions')
            .service('user')
            .edit(user.id, { password: hashedPassword });

        ctx.send({ message: 'Password updated successfully' });
    },
    async register(ctx) {
        // Log semua data request dari Flutter
        console.log("📌 Incoming Register Request:", ctx.request.body);

        const { avatar, username, email, password, phone, first_name, last_name } = ctx.request.body;

        // Validasi Input
        if (!username || !email || !password) {
            return ctx.badRequest("Username, email, and password are required.");
        }

        try {
            // Cek apakah email sudah digunakan
            const existingUser = await strapi.db.query("plugin::users-permissions.user").findOne({ where: { email } });
            if (existingUser) {
                return ctx.badRequest("Email is already taken.");
            }

            // Buat User Baru
            const newUser = await strapi.entityService.create("plugin::users-permissions.user", {
                data: {
                    username,
                    email,
                    password,
                    phone: phone || null,
                    first_name: first_name || null,
                    last_name: last_name || null,
                    avatar: avatar || null
                },
            });

            // Sanitasi Data untuk Response
            const sanitizedUser = await sanitize.contentAPI.output(newUser, strapi.getModel('plugin::users-permissions.user'));

            console.log("✅ User Created Successfully:", sanitizedUser);

            return ctx.send({ user: sanitizedUser });
        } catch (error) {
            console.error("❌ Error in Register Controller:", error);
            return ctx.badRequest("Error registering user.", { error });
        }
    },
}));

*/
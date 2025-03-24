const { sanitize } = require('@strapi/utils');

module.exports = {
    async register(ctx) {
        // Log semua data request dari Flutter
        console.log("📌 Incoming Register Request:", ctx.request.body);

        const { username, email, password, phone, first_name, last_name } = ctx.request.body;

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
    }
};

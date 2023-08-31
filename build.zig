const std = @import("std");

pub fn build(b: *std.Build.Builder) void {
    var optimize = b.standardOptimizeOption(.{});
    var target = b.standardTargetOptions(.{});

    var mongoose_lib = b.addStaticLibrary(.{
        .name = "mongoose_lib",
        .target = target,
        .optimize = optimize,
    });

    mongoose_lib.addIncludePath(.{ .path = "" });
    mongoose_lib.addIncludePath(.{ .path = "src" });
    mongoose_lib.linkLibC();

    mongoose_lib.addCSourceFiles(
        &[_][]const u8{
            "src/base64.c",
            "src/fs_packed.c",
            "src/iobuf.c",
            "src/printf.c",
            "src/rpc.c",
            "src/sntp.c",
            "src/timer.c",
            "src/url.c",
            "src/event.c",
            "src/fs.c",
            "src/log.c",
            "src/mqtt.c",
            "src/str.c",
            "src/ws.c",
            "src/fs_fat.c",
            "src/http.c",
            "src/json.c",
            "src/queue.c",
            "src/sha1.c",
            "src/sock.c",
            "src/util.c",
            "src/dns.c",
            "src/fmt.c",
            "src/md5.c",
            "src/net.c",
            "src/ssi.c",
            "src/tls_dummy.c",
            "src/tls_openssl.c",
            "src/tls_mbed.c",
            "src/fs_posix.c",
        },
        &[_][]const u8{ "-DMG_ENABLE_LINES", "-DMG_TLS=MG_TLS_MBED" },
    );

    var mbedtls_dep = b.dependency("mbedtls", .{});
    var mbedtls_lib = mbedtls_dep.artifact("mbedtls");

    // mongoose_lib.addObjectFile(.{ .path = "ssl/boringssl.lib" });
    // mongoose_lib.addObjectFile(.{ .path = "ssl/boringssl_asm.lib" });

    // mongoose_lib.linkSystemLibrary2("./ssl/boringssl.lib", .{});
    // mongoose_lib.linkSystemLibrary2("./ssl/boringssl_asm.lib", .{});
    mongoose_lib.linkLibrary(mbedtls_lib);
    mongoose_lib.addIncludePath(.{ .path = "ssl/include" });

    var translate_header = b.addTranslateC(.{
        .optimize = optimize,
        .target = target,
        .source_file = .{ .path = "mongoose.h" },
    });

    _ = b.addModule("mongoose", .{ .source_file = .{ .generated = &translate_header.output_file } });
    _ = b.addInstallHeaderFile("mongoose.h", "mongoose.h");

    mongoose_lib.step.dependOn(&translate_header.step);
    b.installArtifact(mongoose_lib);
}

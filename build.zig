const std = @import("std");

pub fn build(b: *std.Build.Builder) void {
    var optimize = b.standardOptimizeOption(.{});
    var target = b.standardTargetOptions(.{});

    var mongoose_lib = b.addStaticLibrary(.{
        .name = "mongoose_lib",
        .target = target,
        .optimize = optimize,
    });

    mongoose_lib.addIncludePath("");
    mongoose_lib.addIncludePath("src");
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
        },
        &[_][]const u8{
            "-DMG_MAX_HTTP_HEADERS=7",
            "-DMG_ENABLE_LINES",
            "-DMG_ENABLE_PACKED_FS=1",
            "-DMG_ENABLE_SSI=1",
            "-DMG_ENABLE_ASSERT=1",
            "-DMG_ENABLE_IPV6=1",
        },
    );

    var translate_header = b.addTranslateC(.{
        .optimize = optimize,
        .target = target,
        .source_file = .{ .path = "mongoose.h" },
    });

    _ = b.addModule("mongoose", .{ .source_file = .{ .generated = &translate_header.output_file } });

    mongoose_lib.step.dependOn(&translate_header.step);
    b.installArtifact(mongoose_lib);
}

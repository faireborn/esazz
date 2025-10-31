pub fn Esazz(
    comptime Char: type,
    comptime NodeInt: type,
    comptime Index: type,
    comptime k: Index,
) type {
    return struct {
        string: []Char,
        suffix_array: []NodeInt,
        left: []NodeInt,
        right: []NodeInt,
        depth: []NodeInt,
        n: Index, // Length of the input string
        k: Index, // Alphabet size
        node_num: Index,
        allocator: std.mem.Allocator,

        const Self = @This();
        fn init(allocator: std.mem.Allocator, string: []Char) !Self {
            const n = string.len;
            return .{
                .string = string,
                .suffix_array = try allocator.alloc(NodeInt, n),
                .left = try allocator.alloc(NodeInt, n),
                .right = try allocator.alloc(NodeInt, n),
                .depth = try allocator.alloc(NodeInt, n),
                .n = n,
                .k = k,
                .node_num = 0,
                .allocator = allocator,
            };
        }

        fn deinit(self: Self) void {
            self.allocator.free(self.suffix_array);
            self.allocator.free(self.left);
            self.allocator.free(self.right);
            self.allocator.free(self.depth);
        }
    };
}

const std = @import("std");

pub fn bufferedPrint() !void {
    // Stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try stdout.flush(); // Don't forget to flush!
}

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try std.testing.expect(add(3, 7) == 10);
}

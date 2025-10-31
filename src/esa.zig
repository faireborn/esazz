pub fn Esazz(
    comptime Char: type,
    comptime NodeInt: type,
    comptime Index: type,
    comptime k: Index,
) type {
    return struct {
        string: []const Char,
        suffix_array: []NodeInt,
        left: []NodeInt,
        right: []NodeInt,
        depth: []NodeInt,
        n: Index, // Length of the input string
        k: Index, // Alphabet size
        node_num: Index,
        allocator: std.mem.Allocator,

        const Self = @This();
        fn init(allocator: std.mem.Allocator, string: []const Char) !Self {
            const n: Index = @intCast(string.len);
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

test "Esazz init deinit" {
    const string = "hello, world";
    const length = string.len;
    const k = 0x110000;
    const esazz = try Esazz(
        u8,
        i32,
        u32,
        k,
    ).init(std.testing.allocator, string);
    defer esazz.deinit();

    try std.testing.expectEqual(esazz.n, length);
    try std.testing.expectEqual(esazz.k, k);
}

test "Esazz array" {
    const string = "abracadabra";
    const length = string.len;
    const esazz = try Esazz(u8, i32, u32, 0x110000).init(std.testing.allocator, string);
    defer esazz.deinit();

    try std.testing.expectEqual(esazz.suffix_array.len, length);
    try std.testing.expectEqual(esazz.left.len, length);
    try std.testing.expectEqual(esazz.right.len, length);
    try std.testing.expectEqual(esazz.depth.len, length);
}

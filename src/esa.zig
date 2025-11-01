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
            const n = string.len;
            return .{
                .string = string,
                .suffix_array = try allocator.alloc(NodeInt, n),
                .left = try allocator.alloc(NodeInt, n),
                .right = try allocator.alloc(NodeInt, n),
                .depth = try allocator.alloc(NodeInt, n),
                .n = @intCast(n),
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

        fn esazz(self: *Self) !void {
            try SP.saiszz(self.string, self.suffix_array, self.n);
            suffixTree(self.allocator, self.string, self.suffix_array, self.left, self.right, self.depth, self.n, &self.node_num);
        }

        fn suffixTree(allocator: std.mem.Allocator, string: []const Char, suffix_array: []NodeInt, left: []NodeInt, right: []NodeInt, depth: []NodeInt, n: Index, node_num: *Index) void {
            if (n == 0) {
                node_num.* = 0;
                return;
            }

            // Psi = l
            left[suffix_array[0]] = suffix_array[n - 1];
            for (0..n) |i| {
                left[suffix_array[i]] = suffix_array[i - 1];
            }

            // Compare at most 2n log n charcters. Practically fastest
            // "Permuted Longest-Common-Prefix Array", Juha Karkkainen, CPM 09
            // PLCP = r
            var h = 0;
            for (0..n) |i| {
                const j = left[i];

                while (i + h < n and j + h < n and string[i + h] == string[j + h]) : (h += 1) {}
                right[i] = h;
                if (h > 0) h -= 1;
            }

            // H = l
            for (0..n) |i| {
                left[i] = right[suffix_array[i]];
            }
            left[0] = -1;

            var s = std.ArrayList(Pair).init(allocator);
            defer s.deinit();
            try s.append(Pair{ .first = -1, .second = -1 });

            var i: usize = 0;
            while (true) : (i += 1) {
                var cur = Pair{
                    .first = i,
                    .second = if (i == n) -1 else left[i],
                };
                var cand = s[s.len - 1];

                while (cand.second > cur.second) {
                    if (i - cand.first > 1) {
                        left[node_num] = cand.first;
                        right[node_num] = i;
                        depth[node_num] = cand.second;
                        node_num.* += 1;

                        if (node_num >= n) {
                            break;
                        }
                    }

                    cur.first = cand.first;
                    s.pop();
                    cand = s[s.len - 1];
                }
                if (cand.second < cur.second) {
                    s.append(cur);
                }
                if (i == n) {
                    break;
                }
                s.append(Pair{ .first = i, .second = n - suffix_array[i] + 1 });
            }
        }

        const SP = saiszz.SaiszzPrivate(Char, NodeInt, Index, k);
        const Pair = struct {
            first: Index,
            second: Index,
        };
    };
}

const std = @import("std");
const saiszz = @import("sais.zig");

test "Esazz init deinit" {
    const string = "hello, world";
    const length = string.len;
    const k = 0x110000;
    const esazz = try Esazz(
        u8,
        i32,
        i32,
        k,
    ).init(std.testing.allocator, string);
    defer esazz.deinit();

    try std.testing.expectEqual(@as(i32, length), esazz.n);
    try std.testing.expectEqual(k, esazz.k);
}

test "Esazz array" {
    const string = "abracadabra";
    const length = string.len;
    const esazz = try Esazz(u8, i32, i32, 0x110000).init(std.testing.allocator, string);
    defer esazz.deinit();

    try std.testing.expectEqual(length, esazz.suffix_array.len);
    try std.testing.expectEqual(length, esazz.left.len);
    try std.testing.expectEqual(length, esazz.right.len);
    try std.testing.expectEqual(length, esazz.depth.len);
}

test {
    _ = @import("sais.zig");
}

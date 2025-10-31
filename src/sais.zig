const std = @import("std");

pub fn SaiszzPrivate(comptime Char: type, comptime NodeInt: type, comptime Index: type, comptime k: Index) type {
    return struct {
        fn saiszz(string: []const Char, suffix_array: []NodeInt, n: Index) !void {
            switch (n) {
                0 => return,
                1 => suffix_array[0] = 0,
                else => return error.InvalidN,
            }
            _ = string;
        }

        fn suffixSort(string: []const Char, suffix_array: []NodeInt, fs: Index, n: Index, isbwt: bool) !void {
            _ = string;
            _ = suffix_array;
            _ = fs;
            _ = n;
            _ = isbwt;
        }

        fn getCounts(string: []const Char, bucket: []Index, n: Index) void {
            for (0..k) |i| {
                bucket[i] = 0; // Initialize all bucket elements with 0
            }

            for (0..n) |i| {
                bucket[string[i]] += 1; // Count frequency of characters
            }
        }
    };
}

test "getCounts" {
    const Index = u32;
    const string = "abracadabra";
    const k = 0x110000;

    var new_string = [_]u32{0} ** string.len;
    for (string, 0..) |c, i| {
        new_string[i] = c;
    }

    const SP = SaiszzPrivate(u32, i32, Index, k);

    const bucket = try std.testing.allocator.alloc(Index, k);
    defer std.testing.allocator.free(bucket);

    SP.getCounts(&new_string, bucket, string.len);

    for (bucket, 0..) |freq, codepoint| {
        switch (codepoint) {
            'a' => try std.testing.expectEqual(5, freq),
            'b' => try std.testing.expectEqual(2, freq),
            'c' => try std.testing.expectEqual(1, freq),
            'd' => try std.testing.expectEqual(1, freq),
            'r' => try std.testing.expectEqual(2, freq),
            else => try std.testing.expectEqual(0, freq),
        }
    }
}

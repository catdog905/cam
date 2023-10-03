#!/usr/bin/env bash
# The MIT License (MIT)
#
# Copyright (c) 2021-2023 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
set -e
set -o pipefail

temp=$1
list=${temp}/temp/filter-lists/invalid-files.txt

java="${temp}/foo/dir (with) _ long & and 'weird' \"name\" /Foo.java"
mkdir -p "$(dirname "${java}")"
echo "class Foo{} class Bar{}" > "${java}"
rm -f "${list}"
msg=$("${LOCAL}/filters/07-delete-invalid-files.sh" "${temp}" "${temp}/temp")
echo "${msg}" | grep "that's why were deleted" >/dev/null
test ! -e "${java}"
test -e "${list}"
test "$(wc -l < "${list}" | xargs)" = 1
echo "👍🏻 An invalid Java file was deleted"

rm -f "${list}"
mkdir -p "${temp}/empty"
msg=$("${LOCAL}/filters/07-delete-invalid-files.sh" "${temp}/empty" "${temp}/temp")
echo "${msg}" | grep "There are no Java classes, nothing to delete" >/dev/null
echo "👍🏻 A empty directory didn't fail the script"

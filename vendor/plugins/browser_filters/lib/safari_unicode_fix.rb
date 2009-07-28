# encoding: iso-8859-1

# Copyright (c) 2005 Thomas Fuchs
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
module SafariUnicodeFix
  def self.included(controller)
    controller.after_filter(:fix_unicode_for_safari)
  end

  private
    def fix_unicode_for_safari
      if headers["Content-Type"] == "text/html; charset=utf-8" && 
          request.env['HTTP_USER_AGENT'] &&
          request.env['HTTP_USER_AGENT'].include?('AppleWebKit') && 
          String === response.body &&
          !response.body.blank?
          response.body = response.body.to_s.gsub(Regexp.new('([^\x00-\xa0])/u', nil, 'n')) { |s| "&#x%x;" % $1.unpack('U')[0] rescue $1 }
      end
    end
end
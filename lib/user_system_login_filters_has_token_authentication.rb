# Copyright (c) 2009 Todd Willey <todd@rubidine.com> 
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

module UserSystemLoginFiltersHasTokenAuthentication
  private
  def lookup_user_with_token_authentication
    token = params[UserSystem.auth_token_name]
    model = self.class.send(:user_model_for_this_controller)
    (token && model.verified.find_by_security_token(token)) || \
      lookup_user_without_token_authentication
  end

  def self.included kls
    unless kls.private_instance_methods.include?(
      'lookup_user_without_token_authentication'
    )
      kls.alias_method_chain :lookup_user, :token_authentication
    end
  end
end

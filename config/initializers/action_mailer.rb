ActionMailer::Base.default charset: 'utf-8'

ActionMailer::Base.register_interceptor(PreventMailInterceptor)
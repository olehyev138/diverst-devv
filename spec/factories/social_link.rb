FactoryBot.define do
  factory :social_link do
    association :author, factory: :user
    association :group, factory: :group

    url 'https://twitter.com/CNN/status/942881446821355520'

    embed_code '<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">
    Former Director of National Intelligence James Clapper: Vladimir Putin &quot;knows how to handle an asset and
     that&#39;s what he&#39;s doing with the President&quot; <a href="https://t.co/KxXPcUNuSA">https://t.co/KxXPcUNuSA</a>
      <a href="https://t.co/CXYiFBCHam">pic.twitter.com/CXYiFBCHam</a></p>&mdash; CNN (@CNN)
      <a href="https://twitter.com/CNN/status/942881446821355520?ref_src=twsrc%5Etfw">December 18, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
'

    trait :without_embed_code do
      embed_code nil
    end
  end
end

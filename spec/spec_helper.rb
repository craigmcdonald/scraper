require 'simplecov'
SimpleCov.start
Dir["#{__dir__.gsub('spec','lib/**/*.rb')}"].reverse.each {|f| require f }
require "#{__dir__}/rails_logger.rb"
Capybara.threadsafe = true
Dotenv.load
require 'billy/capybara/rspec'
Capybara.javascript_driver = :poltergeist_billy
require 'pry'
require "#{__dir__}/fixture_data.rb"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # This allows you to limit a spec run to individual examples or groups
  # you care about by tagging them with `:focus` metadata. When nothing
  # is tagged with `:focus`, all examples get run. RSpec also provides
  # aliases for `it`, `describe`, and `context` that include `:focus`
  # metadata: `fit`, `fdescribe` and `fcontext`, respectively.
  config.filter_run_when_matching :focus

  # Use the documentation formatter for detailed output on a single spec,
  # unless a formatter has already been configured
  # (e.g. via a command-line flag).
  if config.files_to_run.one?
    config.default_formatter = "doc"
  end

  # If you use named caches it is highly recommend that you use a global
  # hook to set the cache back to the default before or after each test.
  # https://github.com/oesmith/puffing-billy#caching
  config.before(:each) { proxy.cache.use_default_scope }

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

end

Billy.configure do |c|
  c.cache = true
  c.persist_cache = true
  c.cache_path = 'spec/fixtures/req_cache/'
  c.non_successful_error_level = :warn
  c.merge_cached_responses_whitelist = [
    /fls.doubleclick.net\/activityi/,
    /dpm.demdex.net/,
    /doubleclick.net/,
    /scorecardresearch.com/,
    /pubmatic.com\/AdServer/,
    /pixel.quantserve.com/,
    /pr-bh.ybp.yahoo.com/,
    /securepubads.g.doubleclick.net/,
    /showads.pubmatic.com/,
    /stats.g.doubleclick.net/,
    /ums.rightmove.co.uk\/users\//,
    /www.facebook.com\/impression.php/,
    /www.facebook.com\/connect\/ping/,
    /www.facebook.com\/impression/,
    /www.google-analytics.com/,
    /bam.nr-data.net/
  ]
  c.ignore_params = ["http://4638770.fls.doubleclick.net,activityi",
                     "https://ad.doubleclick.net/ddm/adj/N5225.1566338.RIGHTMOVE.CO.UKNEW/B11390781.151980391",
                     "http://aktrack.pubmatic.com/AdServer/AdDisplayTrackerServlet",
                     "https://analytics.twitter.com/i/adsct",
                     "http://b.scorecardresearch.com/b2",
                     "https://bam.nr-data.net/1/8ec04da100",
                     "https://bid.g.doubleclick.net/xbbe/pixel",
                     "https://bs.serving-sys.com/BurstingPipe/adServer.bs",
                     "http://c1.adform.net/serving/cookie/match",
                     "https://choices.truste.com/ca",
                     "https://cm.g.doubleclick.net/pixel",
                     "http://dpm.demdex.net/ibs",
                     "http://dpm.demdex.net/demconf.jpg",
                     "http://eur-ukp.adsrvr.org/bid/feedback/pubmatic_ortb",
                     "http://geo-um.btrll.com/v1/map_pixel/partner/1895.png",
                     "https://googleads.g.doubleclick.net/dbm/ad",
                     "https://googleads.g.doubleclick.net/pagead/viewthroughconversion/1013535676/",
                     "https://googleads4.g.doubleclick.net/pcs/view",
                     "https://googleads4.g.doubleclick.net/pcs/view",
                     "http://image2.pubmatic.com/AdServer/Pug",
                     "http://image4.pubmatic.com/AdServer/SPug",
                     "https://impression.appsflyer.com/id334852412",
                     "https://p.typekit.net/p.gif",
                     "https://pagead2.googlesyndication.com/pagead/gen_204",
                     "http://pixel.adsafeprotected.com/mon",
                     "http://pixel.adsafeprotected.com/jload",
                     "http://pixel.quantserve.com/pixel",
                     "https://rbs.demdex.net/event",
                     "https://securepubads.g.doubleclick.net/pcs/view",
                     "http://showads.pubmatic.com/AdServer/AdServerServlet",
                     "http://staticxx.facebook.com/connect/xd_arbiter/r/0F7S7QWJ0Ac.js",
                     "https://stats.g.doubleclick.net/r/collect",
                     "https://sync.adap.tv/sync",
                     "http://sync.adaptv.advertising.com/sync",
                     "http://sync.mathtag.com/sync/img",
                     "http://t.co/i/adsct",
                     "http://sync.mathtag.com/sync/img",
                     "http://tags.bluekai.com/site/3096",
                     "http://ums.rightmove.co.uk/users/170613ROVEWIGL03TGDCDND4HNJAXABZ",
                     "http://usync.nexage.com/mapuser",
                     "https://www.facebook.com/impression.php/f214663e6c/",
                     "https://www.facebook.com/tr/",
                     "http://www.google-analytics.com/collect",
                     "http://www.google-analytics.com/__utm.gif",
                     "https://www.google.co.uk/ads/user-lists/1013535676/",
                     "http://www.rightmove.co.uk/ps/images/logging/timer.gif",
                     "http://www.rightmove.co.uk/ps/images/analytics/page_view.gif"

                   ]
end

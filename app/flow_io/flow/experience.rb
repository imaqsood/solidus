# Flow.io (2017)
# communicates with flow api, easy access
# to basic shop frontend and backend needs

module Flow::Experience
  extend self

  def all no_world=nil
    experiences = get_from_flow
    no_world ? experiences.select{ |exp| exp.key != 'world' } : experiences
  end

  def keys
    all.map{ |el| el.key }
  end

  def get key
    all.each do |exp|
      return exp if exp.key == key
    end
    nil
  end

  def compact
    all.map { |exp| [exp.country, exp.key, exp.name] }
  end

  def default
    Flow::Experience.all.select{ |exp| exp.key == 'united-states-of-america' }.first
  end

  private

  def get_from_flow
    return cached_experinces if cache_valid?

    experiences = FlowCommerce.instance.experiences.get(Flow.organization)
    @cache = [experiences, Time.now]
    experiences
  end

  def cache_valid?
    # cache experinces in worker memory for 1 minute
    @cache && @cache[1] > Time.now.ago(1.minute)
  end

  def cached_experinces
    @cache[0]
  end

end
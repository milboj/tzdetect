
module TZDetect
  module Error
    class Base < StandardError; end
    class Configuration < Base; end
    class Parser < Base; end
    class GeoCoder < Base; end
  end
end

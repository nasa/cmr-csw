module WelcomeHelper
  def to_schema_label schema
    label = 'unknown'
    if schema ==  'http://www.opengis.net/cat/csw/2.0.2'
      label = 'CSW'
    elsif schema == 'http://www.isotc211.org/2005/gmi'
      label = 'ISO GMI'
    elsif schema == 'http://www.isotc211.org/2005/gmd'
      label = 'ISO GMD'
    end
    label
  end
end

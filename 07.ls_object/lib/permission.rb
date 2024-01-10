# frozen_string_literal: true

module Permission
  module Private
    PERMISSIONS = {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }.freeze

    TYPES = {
      '01' => 'p',
      '02' => 'c',
      '04' => 'd',
      '06' => 'b',
      '10' => '-',
      '12' => 'l',
      '14' => 's'
    }.freeze
  end
  private_constant :Private

  def self.permission(mode)
    formatted_mode = format_mode(mode)

    [Private::TYPES[formatted_mode[0, 2]], Private::PERMISSIONS[formatted_mode[3]], Private::PERMISSIONS[formatted_mode[4]],
     Private::PERMISSIONS[formatted_mode[5]], '@'].join
  end

  def self.format_mode(mode)
    mode.to_s(8).rjust(6, '0')
  end
  private_class_method :format_mode
end

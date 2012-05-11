class BroadcastCell < UITableViewCell
  attr_accessor :index_path, :series_title_and_episode_number, :episode_title, :airtime_and_channel

  CellID = 'CellIdentifier'
  MessageFontSize = 14
  SmallMessageFontSize = 12

  POSTER_ASPECT_RATIO = 0.679802955665025
  MARGIN = 8
  MARGIN_UNDERNEATH_LABEL = 2


  def self.cellForBroadcast(broadcast, indexPath:indexPath, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(BroadcastCell::CellID) || BroadcastCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
    cell.index_path = indexPath
    cell.fillWithBroadcast(broadcast, inTableView:tableView)
    cell
  end

  def initWithStyle(style, reuseIdentifier:cellid)
    if super
      self.series_title_and_episode_number = UILabel.new
      self.series_title_and_episode_number.opaque = true
      self.series_title_and_episode_number.font = UIFont.systemFontOfSize(MessageFontSize)
      self.contentView.addSubview series_title_and_episode_number

      self.episode_title = UILabel.new
      self.episode_title.opaque = true
      self.episode_title.font = UIFont.systemFontOfSize(SmallMessageFontSize)
      self.contentView.addSubview episode_title

      self.airtime_and_channel = UILabel.new
      self.airtime_and_channel.opaque = true
      self.airtime_and_channel.font = UIFont.systemFontOfSize(SmallMessageFontSize)
      self.contentView.addSubview airtime_and_channel
    end
    self
  end

  def fillWithBroadcast(broadcast, inTableView:tableView)
    show, episode = broadcast[:show], broadcast[:episode]

    self.textLabel.text = show.title

    unless show.poster
      self.imageView.image = nil
      Dispatch::Queue.concurrent.async do
        image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(show.poster_url))
        if image_data
          show.poster = UIImage.alloc.initWithData(image_data)

          Dispatch::Queue.main.sync do
            self.imageView.image = show.poster
            self.imageView.opaque = true;
            self.imageView.layer.masksToBounds = true;
            self.imageView.layer.cornerRadius = 2.0;
            #self.imageView.layer.minificationFilter = kCAFilterTrilinear;

            tableView.delegate.reloadRowForBroadcast({:show => show, :episode => episode}, index_path)
          end
        end
      end
    else
      self.imageView.image = show.poster
    end
  end

  def layoutSubviews
    super

    size = self.bounds.size;
    x = 0
    y = 0
    imageWidth, labelWidth, labelHeight = 0

    # Poster
    imageWidth = (size.height * POSTER_ASPECT_RATIO).floor
    imageSize = CGSizeMake(imageWidth, size.height)
    self.imageView.frame = CGRectMake(x, y, imageSize.width, imageSize.height)

    # Show title and episode number
    x += imageWidth + MARGIN
    y += MARGIN
    labelWidth = size.width - x
    labelHeight = systemFontSize + MARGIN_UNDERNEATH_LABEL
    self.series_title_and_episode_number.frame = CGRectMake(x, y, labelWidth, labelHeight)

    # Epsiode title
    y += labelHeight + MARGIN_UNDERNEATH_LABEL
    labelHeight = SmallMessageFontSize + MARGIN_UNDERNEATH_LABEL
    self.episode_title.frame = CGRectMake(x, y, labelWidth, labelHeight)

    # Airtime and channel
    y += labelHeight + MARGIN_UNDERNEATH_LABEL
    self.airtime_and_channel.frame = CGRectMake(x, y, labelWidth, labelHeight)
  end
end

class BroadcastCell < UITableViewCell
  attr_accessor :index_path

  CellID = 'CellIdentifier'
  MessageFontSize = 14

  def self.cellForBroadcast(broadcast, indexPath:indexPath, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(BroadcastCell::CellID) || BroadcastCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
    cell.index_path = indexPath
    cell.fillWithBroadcast(broadcast, inTableView:tableView)
    cell
  end

  def initWithStyle(style, reuseIdentifier:cellid)
    if super
      self.textLabel.numberOfLines = 0
      self.textLabel.font = UIFont.systemFontOfSize(MessageFontSize)
    end
    self
  end

  def fillWithBroadcast(broadcast, inTableView:tableView)
    show, episode = broadcast[:show], broadcast[:episode]

    self.textLabel.text = show.title

    unless episode.image
      self.imageView.image = nil
      Dispatch::Queue.concurrent.async do
        image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(episode.image_url))
        if image_data
          episode.image = UIImage.alloc.initWithData(image_data)

          Dispatch::Queue.main.sync do
            self.imageView.image = episode.image
            self.imageView.opaque = true;
            self.imageView.layer.masksToBounds = true;
            self.imageView.layer.cornerRadius = 2.0;
            #self.imageView.layer.minificationFilter = kCAFilterTrilinear;

            tableView.delegate.reloadRowForBroadcast({:show => show, :episode => episode}, index_path)
          end
        end
      end
    else
      self.imageView.image = episode.image
    end
  end

  def self.heightForBroadcast(broadcast, width)
    constrain = CGSize.new(width - 95, 1000)
    size = broadcast[:show].title.sizeWithFont(UIFont.systemFontOfSize(MessageFontSize), constrainedToSize:constrain)
    [57, size.height + 8].max
  end

  def layoutSubviews
    super
    self.imageView.frame = CGRectMake(2, 2, 88, 49)
    label_size = self.frame.size
    self.textLabel.frame = CGRectMake(95, 0, label_size.width - 59, label_size.height)
  end
end

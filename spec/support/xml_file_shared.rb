shared_examples 'xml file' do | root_tag, child_tags |

  it 'containing required tags' do
    child_tags.each do |tag|
      should match(/<#{root_tag}>?.+#{tag}?.+<\/#{root_tag}>/m)
    end
  end

end
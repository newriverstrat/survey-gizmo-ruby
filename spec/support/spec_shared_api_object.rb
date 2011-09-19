shared_examples_for 'an API object' do
  it "#new?" do
    described_class.new.should be_new
  end
  
  
  it '#reload' do
    stub_request(:get, /#{@base}/).to_return(json_response(true, get_attributes))
    obj = described_class.new(create_attributes)
    obj.attributes.reject{|k,v| v.blank? }.should == create_attributes
    obj.reload
    obj.attributes.reject{|k,v| v.blank? }.should == get_attributes
  end
  
  it '#valid?'
  it "should be in zombie state if requests fail"
  
  context "create" do
    it "should make a request" do
      stub_api_call(:put)
      described_class.create(create_attributes)
      a_request(:put, @base).with(:query => request_params(create_attributes)).should have_been_made
    end
    
    it "should return a new instance" do
      stub_api_call(:put)
      obj = described_class.create(create_attributes)
      obj.should be_instance_of(described_class)
    end
    
    it "should set the attributes" do
      stub_request(:put, /#{@base}/).to_return(json_response(true, create_attributes))
      obj = described_class.create(create_attributes)
      obj.attributes.reject{|k,v| v.blank? }.should == create_attributes
    end
  end
  
  context "get" do
    it "should make a request" do
      stub_request(:get, /#{@base}/).to_return(json_response(true, get_attributes))
      described_class.get(1234)
      a_request(:get, /#{@base}\/1234/).should have_been_made
    end
  
    it "should set the attributes" do
      stub_request(:get, /#{@base}/).to_return(json_response(true, get_attributes))
      obj = described_class.get(1234)
      obj.title.should == 'Spec'
      obj.id.should == 1234
    end
  
    it "should return false if the request fails" do
      stub_request(:get, /#{@base}/).to_return(json_response(false, "something is wrong"))
      described_class.get(1234).should == false
    end
  end
  
  context "update" do
    before(:each) do
      @obj = described_class.new(get_attributes)
      @obj.__send__(:clean!)
    end
    
    it "should make a request" do
      stub_api_call(:post)
      @obj.update
      a_request(:post, /#{@base}\/1234/).should have_been_made
    end
    
    it 'should change object state to saved' do
      stub_api_call(:post)
      @obj.update(update_attributes)
      @obj.should be_saved
    end
    
    it "should not be marked saved if the request fails" do
      stub_api_call(:post, false)
      @obj.update
      @obj.should_not be_saved
    end
    
    xit "cannot be updated if new" do
      @obj.instance_variable_set('@_state', nil)
      @obj.update(update_attributes).should be_false
    end
    
  end
  
  context "destroy" do
    before(:each) do
      @obj = described_class.new(get_attributes)
      @obj.__send__(:clean!)
    end
    
    it "should make a request" do
      stub_api_call(:delete)
      @obj.destroy
      a_request(:delete, /#{@base}\/1234/).should have_been_made
    end
    
    it 'should change object state to destroyed' do
      stub_api_call(:delete)
      @obj.destroy
      @obj.should be_destroyed
    end
    
    it "should not be marked destroyed if the request fails" do
      stub_api_call(:delete, false)
      @obj.destroy
      @obj.should_not be_destroyed
    end
    
    it "cannot be destroyed if new" do
      @obj.instance_variable_set('@_state', nil)
      @obj.destroy.should be_false
    end
  end
end
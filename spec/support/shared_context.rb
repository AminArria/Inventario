shared_context "env" do
  let(:vmware_instance_cpu) { ENV["vmware_instance_cpu"].to_f }
  let(:vmware_instance_memory) { ENV["vmware_instance_memory"].to_f }
  let(:vmware_instance_disk) { ENV["vmware_instance_disk"].to_f }
end
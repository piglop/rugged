require "test_helper"
require 'net/http'

context "Rugged::Tag tests" do
  setup do
    @path = File.dirname(__FILE__) + '/fixtures/testrepo.git/'
    @repo = Rugged::Repository.new(@path)
  end

  test "is able to connect to the remote" do
    begin
      Net::HTTP.new('github.com').head('/')
    rescue SocketError => msg
      skip "github is not reachable: #{msg}"
    end

    remote = Rugged::Remote.new(@repo, "git://github.com/libgit2/libgit2.git")

    remote.connect(:fetch) do |r|
      assert r.connected?
    end

    assert !remote.connected?
  end

  test "can list remotes" do
    remotes = @repo.remotes
    assert remotes.kind_of? Enumerable
    assert_equal [ "libgit2" ], remotes.to_a
  end

end

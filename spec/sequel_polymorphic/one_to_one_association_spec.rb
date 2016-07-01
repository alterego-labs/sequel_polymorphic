require File.dirname(__FILE__) + '/../spec_helper'

describe Sequel::Plugins::Polymorphic do
  describe "one-to-one association" do
    before do
      Post.dataset.delete
      Question.dataset.delete
      Media.dataset.delete

      @post = Post.create(name: 'test post')
      @question = Question.create
      @media = Media.create
    end

    describe 'with default class detecting' do
      describe "#association" do
        it "should return associated object" do
          @question.add_post(@post)
          assert_equal @post.postable, @question
          assert_equal @question.post, @post
        end
      end

      describe "#association=" do
        it "should set association" do
          @post.postable = @question
          @post.save
          @question.refresh
          assert_equal @question.post, @post
        end
      end
    end

    describe 'with custom class' do
      describe "#association" do
        it "should return associated object" do
          @post.add_picture(@media)
          assert_equal @post.picture, @media
          assert_equal @media.mediable, @post
        end
      end

      describe "#association=" do
        it "should set association" do
          @media.mediable = @post
          @media.save
          @post.refresh
          assert_equal @post.picture, @media
        end
      end
    end
  end
end

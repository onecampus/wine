class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :provider
      can :manage, User
      can :manage, Cat
      can :manage, Site
      can :manage, Inventory
      can :manage, Tag
    elsif user.has_role? :customer
      can :manage, Site
    else
      can :manage, Site
    end
  end
end

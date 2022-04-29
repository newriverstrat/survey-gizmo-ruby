# This REST endpoint is only available to accounts with admin privileges
# This code is untested.

module SurveyGizmo::API
  class AccountTeams
    include SurveyGizmo::Resource

    attribute :id,            Integer
    attribute :teamid,        Integer
    attribute :teamname,      String
    attribute :color,         String
    attribute :default_role,  String
    attribute :status,        String

    # v5 fields
    attribute :team_name,     String
    attribute :description,   String

    @route = '/accountteams'
  end
end

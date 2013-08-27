module DetailsHelper
  def set_class(state)
    return "" if [1,9].include? state.id
    return "warning" if [2].include? state.id
    return "success" if [8].include? state.id
    return "danger"
  end
end

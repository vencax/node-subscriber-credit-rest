
exports.countBalance = (uid, model) ->
  model.findAll(where: uid: uid).then (changes) ->
    state = 0
    changes.forEach (ch) ->
      state += ch.amount
    return state

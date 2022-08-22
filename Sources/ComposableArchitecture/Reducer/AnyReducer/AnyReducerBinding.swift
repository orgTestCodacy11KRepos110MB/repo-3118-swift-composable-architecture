extension AnyReducer where Action: BindableAction, State == Action.State {
  /// Returns a reducer that applies ``BindingAction`` mutations to `State` before running this
  /// reducer's logic.
  ///
  /// For example, a settings screen may gather its binding actions into a single
  /// ``BindingAction`` case by conforming to ``BindableAction``:
  ///
  /// ```swift
  /// enum SettingsAction: BindableAction {
  ///   ...
  ///   case binding(BindingAction<SettingsState>)
  /// }
  /// ```
  ///
  /// The reducer can then be enhanced to automatically handle these mutations for you by tacking
  /// on the ``binding()`` method:
  ///
  /// ```swift
  /// let settingsReducer = AnyReducer<SettingsState, SettingsAction, SettingsEnvironment> {
  ///   ...
  /// }
  /// .binding()
  /// ```
  ///
  /// - Returns: A reducer that applies ``BindingAction`` mutations to `State` before running this
  ///   reducer's logic.
  public func binding() -> Self {
    Self { state, action, environment in
      guard let bindingAction = (/Action.binding).extract(from: action)
      else {
        return self.run(&state, action, environment)
      }

      bindingAction.set(&state)
      return self.run(&state, action, environment)
    }
  }
}
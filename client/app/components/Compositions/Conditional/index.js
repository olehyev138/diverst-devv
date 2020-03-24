import React, { useContext } from 'react';
import { connect } from 'react-redux';
import { push } from 'connected-react-router';
import dig from 'object-dig';
import NotAuthorizedPage from 'containers/Shared/NotAuthorizedPage';

import PropTypes from 'prop-types';
import { showSnackbar } from 'containers/Shared/Notifier/actions';
import RouteService from 'utils/routeHelpers';

function conditionalCheck(props, condition) {
  const parts = condition.split('.');
  return dig(...[props, ...parts]);
}

function conditionsMapper(props, conditions) {
  return conditions.map(cond => conditionalCheck(props, cond));
}

function valid(props, conditions, reducer) {
  return reducer(conditionsMapper(props, conditions));
}

export default function Conditional(
  Component,
  conditions,
  redirect = null,
  message = 'You don\'t have permission to view this page',
  reducer = a => a.reduce((sum, v) => sum || v, false)
) {
  const WrappedComponent = (props) => {
    if (valid(props, conditions, reducer))
      return <Component {...props} />;
    if (redirect) {
      const rs = props.computedMatch
        ? new RouteService({ computedMatch: props.computedMatch, location: props.location })
        : new RouteService(useContext);
      props.dispatch(showSnackbar({ message, options: { variant: 'warning' } }));
      props.dispatch(push(redirect(props, rs)));
      return <React.Fragment />;
    }

    return <NotAuthorizedPage />;
  };

  WrappedComponent.propTypes = {
    show: PropTypes.bool,
    valid: PropTypes.func,
    dispatch: PropTypes.func,
    computedMatch: PropTypes.object,
    location: PropTypes.object,
  };

  return connect()(WrappedComponent);
}

import React, { useContext, useEffect } from 'react';
import { compose } from 'redux';
import { createStructuredSelector } from 'reselect';
import { connect } from 'react-redux';
import { push, goBack } from 'connected-react-router';
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

const redirectAction = (redirect, props, rs) => push(redirect(props, rs));

export default function Conditional(
  Component,
  conditions,
  redirect = null,
  message = null,
  reducer = a => a.reduce((sum, v) => sum || v, false)
) {
  const WrappedComponent = (props) => {
    const show = valid(props, conditions, reducer);

    useEffect(() => {
      if (!show && redirect) {
        const rs = props.computedMatch
          ? new RouteService({ computedMatch: props.computedMatch, location: props.location })
          : new RouteService(useContext);
        props.redirectAction(redirect, props, rs);

        if (message)
          props.showSnackbar({ message, options: { variant: 'warning' } });
      }

      return () => null;
    });

    if (show)
      return <Component {...props} />;
    if (redirect)
      return <React.Fragment />;

    return <NotAuthorizedPage />;
  };

  WrappedComponent.propTypes = {
    showSnackbar: PropTypes.func,
    redirectAction: PropTypes.func,
    computedMatch: PropTypes.object,
    location: PropTypes.object,
  };

  const mapDispatchToProps = {
    redirectAction,
    showSnackbar,
  };

  const withConnect = connect(
    createStructuredSelector({}),
    mapDispatchToProps,
  );

  return compose(
    withConnect
  )(WrappedComponent);
}

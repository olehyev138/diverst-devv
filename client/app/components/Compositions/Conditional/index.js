import React, { useEffect, useState } from 'react';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { useParams, useLocation } from 'react-router-dom';
import dig from 'object-dig';
import NotAuthorizedPage from 'containers/Shared/NotAuthorizedPage';

import PropTypes from 'prop-types';
import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { injectIntl, intlShape } from 'react-intl';
import { redirectAction } from 'utils/reduxPushHelper';
import config from 'app.config';
import { DiverstFormattedMessage } from '../../Shared/DiverstFormattedMessage';

function conditionalCheck(props, condition) {
  let parts;
  const neg = condition[0] === '!';
  if (condition[0] === '!')
    parts = condition.substr(1).split('.');
  else
    parts = condition.split('.');
  const evaluated = dig(...[props, ...parts]);
  if (evaluated == null)
    return undefined;
  return neg ? !evaluated : evaluated;
}

function conditionsMapper(props, conditions) {
  return conditions.map(cond => conditionalCheck(props, cond));
}

function valid(props, conditions, reducer) {
  if (reducer(conditionsMapper(props, conditions)))
    return true;
  if (config.environment === 'development') {
    // eslint-disable-next-line no-console
    console.log('Failed Permissions');
    // eslint-disable-next-line no-console
    console.log(conditions.reduce((sum, cond) => {
      sum[cond] = conditionalCheck(props, cond);
      return sum;
    }, {}));
  }
  return false;
}

export default function Conditional(
  Component,
  conditions,
  redirect = null,
  message = null,
  wait = false,
  reducer = a => a.some(v => v) || a.every(v => v === undefined)
) {
  const WrappedComponent = (props) => {
    const [first, setFirst] = useState(true);
    const show = valid(props, conditions, reducer);
    const params = useParams();
    const location = useLocation();

    const path = redirect && redirect(props, params, location);

    useEffect(() => {
      if (!show && wait && first)
        setFirst(false);
      else if (!show && path) {
        props.redirectAction(path);
        if (message)
          props.showSnackbar({
            message: typeof message === 'object' ? <DiverstFormattedMessage {...message} /> : message,
            options: { variant: 'warning' }
          });
      }

      return () => null;
    });

    if (show)
      return <Component {...props} />;
    if (path)
      return <React.Fragment />;

    return <NotAuthorizedPage />;
  };

  WrappedComponent.propTypes = {
    intl: intlShape.isRequired,
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
    undefined,
    mapDispatchToProps,
  );

  return compose(
    withConnect,
    injectIntl,
  )(WrappedComponent);
}

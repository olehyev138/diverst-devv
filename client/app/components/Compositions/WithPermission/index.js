import React, { memo } from 'react';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import PropTypes from 'prop-types';
import { selectUserPolicyGroup } from 'containers/Shared/App/selectors';

// This component is intended for rendering images from a base64 string,
// likely image data encoded in base64 received from a serializer.
export default function Permission(Component) {
  const WrappedComponent = ({ permissions, predicate, policyGroup, ...props }) => {
    const pred = predicate || ((args, permissions) => args.reduce((sum, part) => sum && permissions[part], true));
    const valid = pred(permissions, policyGroup);

    return valid
      ? <Component {...props} />
      : <React.Fragment />;
  };

  WrappedComponent.propTypes = {
    policyGroup: PropTypes.object.isRequired,
    permissions: PropTypes.array.isRequired,
    predicate: PropTypes.func,
  };

  const mapStateToProps = createStructuredSelector({
    policyGroup: selectUserPolicyGroup(),
  });

  const mapDispatchToProps = {
  };

  const withConnect = connect(
    mapStateToProps,
    mapDispatchToProps,
  );

  return compose(
    withConnect,
  )(WrappedComponent);
}

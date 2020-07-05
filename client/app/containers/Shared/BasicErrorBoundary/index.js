import React from 'react';
import PropTypes from 'prop-types';

class BasicErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null, info: null };
  }

  static getDerivedStateFromError(error, info) {
    // Update state so the next render will show the fallback UI.
    return { hasError: true, error, info };
  }

  componentDidCatch(error, info) {
    // TODO: Handle the error
    /* eslint-disable-next-line no-console */
    console.log(error);
  }

  render() {
    const ErrorRender = this.props.render;

    if (this.state.hasError)
      // You can render any custom fallback UI
      return <ErrorRender error={this.state.error} info={this.state.info} />;


    return this.props.children;
  }
}

BasicErrorBoundary.propTypes = {
  children: PropTypes.node,
  render: PropTypes.oneOfType([PropTypes.node.isRequired, PropTypes.func, PropTypes.string]),
};

export default BasicErrorBoundary;

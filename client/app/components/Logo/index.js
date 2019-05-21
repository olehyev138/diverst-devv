import React from "react";
import { connect } from "react-redux";
import { compose } from "redux";
import { createStructuredSelector } from "reselect";
import dig from "object-dig";


// TODO: put this in App/
import { selectEnterprise } from "./selectors";

import defaultLogo from "images/diverst.png";
import styled from 'styled-components';

export class Logo extends React.PureComponent {

  render() {
    let logo = null;
    const logoLocation = dig(this.props.enterprise, 'theme', 'logo_location');

    if (logoLocation)
      logo = logoLocation;
    else
      logo = defaultLogo;

    let className = this.props.imgClass || 'tiny-img';
    let margin = this.props.margin || 0;

    return (
      <img className={className} src={logo} alt='diverst Logo' style={{marginRight: margin}}/>
    );
  }
}

export function mapDispatchToProps(dispatch, ownProps) {
  return {
  };
}

const mapStateToProps = createStructuredSelector({
  enterprise: selectEnterprise()
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
)(Logo);

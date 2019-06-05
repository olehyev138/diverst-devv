import React from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { createStructuredSelector } from 'reselect';
import dig from 'object-dig';
import classNames from 'classnames';
import { withStyles } from '@material-ui/core/styles';


// TODO: put this in App/
import { selectEnterprise } from './selectors';

import defaultLogo from 'images/diverst-logo.svg';
import defaultLogoPrimary from 'images/diverst-logo-purple.svg';

const styles = theme => ({
  spacing: {
    marginRight: 0,
    paddingTop: 0,
    paddingBottom: 0,
  },
});

export class Logo extends React.PureComponent {
  render() {
    const { classes } = this.props;

    let logo = null;
    const logoLocation = dig(this.props.enterprise, 'theme', 'logo_location');

    if (logoLocation) logo = logoLocation;
    else if (this.props.coloredDefault) logo = defaultLogoPrimary;
    else logo = defaultLogo;

    const className = this.props.imgClass || 'tiny-img';
    const alt = this.props.alt || 'Diverst Logo';

    return (
      <img
        className={classNames(this.props.className, className, classes.spacing)}
        src={logo}
        alt={alt}
      />
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
  withStyles(styles),
)(Logo);

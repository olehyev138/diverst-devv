import React, { memo, useEffect, useState } from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { createStructuredSelector } from 'reselect';
import dig from 'object-dig';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import { Button } from '@material-ui/core';

import { selectEnterprise } from 'containers/Shared/App/selectors';

import defaultLogo from 'images/diverst-logo.svg';
import defaultLogoPrimary from 'images/diverst-logo-purple.svg';

import DiverstImg from 'components/Shared/DiverstImg';

const styles = theme => ({
  button: {
    display: 'block',
  },
  logoPadding: {
    paddingTop: 5,
    paddingBottom: 5,
  },
});

export function Logo(props) {
  const { classes, dispatch, ...rest } = props;

  const className = props.imgClass;
  const alt = props.alt || 'Logo';

  const currentURLWithoutPath = `${window.location.protocol}//${window.location.host}`;

  let isDefault = true;
  let logo = props.coloredDefault ? defaultLogoPrimary : defaultLogo;
  let logoRedirectUrl = (dig(props.enterprise, 'theme', 'logo_redirect_url') || currentURLWithoutPath).toLowerCase(); // Defaults to current URL without path
  const logoContentType = dig(props.enterprise, 'theme', 'logo_content_type');

  const logoData = dig(props.enterprise, 'theme', 'logo_data');

  if (logoData) {
    logo = logoData;
    isDefault = false;
  }

  // To prevent odd append redirects, add 'https://' to the URL unless the URL is a relative path, or already has the protocol
  if (logoRedirectUrl && !logoRedirectUrl.startsWith('/') && !logoRedirectUrl.startsWith('https://') && !logoRedirectUrl.startsWith('http://'))
    logoRedirectUrl = `https://${logoRedirectUrl}`;

  const imageComponent = (
    <DiverstImg
      // If it's default add some bottom padding as the SVGs have no padding
      className={isDefault ? classes.logoPadding : undefined}
      data={logo}
      contentType={logoContentType}
      alt={alt}
      naturalSrc={!logoData}
      {...rest}
    />
  );

  if (props.withLink && logoRedirectUrl)
    return (
      // eslint-disable-next-line no-return-assign
      <Button onClick={() => window.location.href = logoRedirectUrl} className={classes.button}>
        {imageComponent}
      </Button>
    );

  return (
    <React.Fragment>
      {imageComponent}
    </React.Fragment>
  );
}

Logo.propTypes = {
  classes: PropTypes.object,
  dispatch: PropTypes.func,
  className: PropTypes.string,
  enterprise: PropTypes.object,
  coloredDefault: PropTypes.bool,
  withLink: PropTypes.bool,
  imgClass: PropTypes.string,
  alt: PropTypes.string,
};

const mapStateToProps = createStructuredSelector({
  enterprise: selectEnterprise()
});

const withConnect = connect(
  mapStateToProps,
);

export default compose(
  memo,
  withConnect,
  withStyles(styles),
)(Logo);

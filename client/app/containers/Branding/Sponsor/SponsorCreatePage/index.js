import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from '../reducer';
import saga from '../saga';
import {
  createSponsorBegin,
  sponsorsUnmount
} from '../actions';

import RouteService from 'utils/routeHelpers';
import SponsorForm from 'components/Branding/Sponsor/SponsorForm';

export function SponsorCreatePage(props) {
  useInjectReducer({ key: 'sponsors', reducer });
  useInjectSaga({ key: 'sponsors', saga });

  useEffect(() => () => props.sponsorsUnmount(), []);

  return (
    <React.Fragment>
      <SponsorForm
        sponsorAction={props.createSponsorBegin}
        buttonText='Create'
      />
    </React.Fragment>
  );
}

SponsorCreatePage.propTypes = {
  createSponsorBegin: PropTypes.func,
  sponsorsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
});

const mapDispatchToProps = {
  createSponsorBegin,
  sponsorsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(SponsorCreatePage);

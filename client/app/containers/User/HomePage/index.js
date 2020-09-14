/**
 *
 * HomePage
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';

import messages from './messages';

import Events from '../UserEventsPage';
import News from '../UserNewsFeedPage';
import SponsorCard from 'components/Branding/Sponsor/SponsorCard';
import { selectSponsorTotal } from 'containers/Shared/Sponsors/selectors';

import {
  Typography, Grid, CardContent, Paper,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import DiverstDialog from 'components/Shared/DiverstDialog';
import EventsList from 'components/Event/HomeEventsList';
import NewsFeed from 'components/News/HomeNewsList';

import { injectIntl, intlShape } from 'react-intl';
import { selectEnterprise, selectPermissions } from 'containers/Shared/App/selectors';
import DiverstHTMLEmbedder from 'components/Shared/DiverstHTMLEmbedder';
import DiverstImg from 'components/Shared/DiverstImg';
import { DiverstCSSGrid, DiverstCSSCell } from 'components/Shared/DiverstCSSGrid';

import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';

const styles = theme => ({
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    paddingBottom: theme.spacing(1),
  },
  dataHeaders: {
    paddingBottom: theme.spacing(1),
  },
  privacyStatement: {
    padding: theme.spacing(1),
    textDecoration: 'underline',
  }
});

/* eslint-disable react/prefer-stateless-function */
export class HomePage extends React.PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      open: false
    };
  }

  handleClickOpen = () => {
    this.setState({ open: true });
  };

  handleClose = () => {
    this.setState({ open: false });
  };

  render() {
    const { classes } = this.props;

    const content = (
      <Grid container spacing={2} direction='row'>
        <Permission show={permission(this.props, 'news_view')}>
          <Grid item xs>
            <Paper>
              <CardContent>
                <Typography variant='h5' className={classes.title}>
                  <DiverstFormattedMessage {...messages.news} />
                </Typography>
                <News
                  listComponent={NewsFeed}
                  readonly
                />
              </CardContent>
            </Paper>
          </Grid>
        </Permission>
        <Permission show={permission(this.props, 'events_view')}>
          <Grid item xs>
            <Paper>
              <CardContent>
                <Typography variant='h5' className={classes.title}>
                  <DiverstFormattedMessage {...messages.events} />
                </Typography>
                <Events
                  listComponent={EventsList}
                  readonly
                  loaderProps={{
                    transitionProps: {
                      direction: 'right',
                    },
                  }}
                />
              </CardContent>
            </Paper>
          </Grid>
        </Permission>
      </Grid>
    );

    const privacyMessage = this.props.enterprise ? this.props.enterprise.privacy_statement !== '' && (
      <React.Fragment>
        <Typography onClick={this.handleClickOpen} className={classes.privacyStatement} color='primary' display='inline'>
          <DiverstFormattedMessage {...messages.privacy} />
        </Typography>
        <DiverstDialog
          open={this.state.open}
          handleNo={this.handleClose}
          textNo={this.props.intl ? this.props.intl.formatMessage(messages.close) : ' '}
          content={(
            <DiverstHTMLEmbedder
              html={
                this.props.enterprise
                  ? this.props.enterprise.privacy_statement
                  : ''
              }
            />
          )}
          title={this.props.intl ? this.props.intl.formatMessage(messages.privacy) : ' '}
        />
      </React.Fragment>
    ) : null;

    const sponsor = (
      <SponsorCard
        type='enterprise'
        currentGroup={null}
      />
    );

    const enterpriseMessage = (
      <DiverstHTMLEmbedder
        html={
          this.props.enterprise
            ? this.props.enterprise.home_message
            : ''
        }
      />
    );

    const enterpriseImage = this.props.enterprise ? this.props.enterprise.banner_data && (
      <DiverstImg
        data={this.props.enterprise.banner_data}
        contentType={this.props.enterprise?.banner_content_type}
        alt=''
        maxWidth='100%'
        minWidth='100%'
      />
    ) : null;


    const grid = this.props.sponsorTotal > 0 ? [
      'header header  header  header  header  header  header  header  header  header',
      'message message  message  message  message  message  message  message  message  message',
      'content content content content content content content content  sponsor sponsor',
      'content content content content content content content content  sponsor sponsor',
      'content content content content content content content content  sponsor sponsor',
      'privacy privacy  privacy  privacy  privacy  privacy  privacy  privacy  privacy  privacy',

    ] : [
      'header header  header  header  header  header  header  header  header  header',
      'message message  message  message  message  message  message  message  message  message',
      'content content content content content content content content content content',
      'content content content content content content content content content content',
      'content content content content content content content content content content',
      'privacy privacy  privacy  privacy  privacy  privacy  privacy  privacy  privacy  privacy',

    ];

    return (
      <DiverstCSSGrid
        columns={10}
        rows='auto auto auto auto 1fr'
        areas={grid}
        rowGap='16px'
        columnGap='24px'
      >
        <DiverstCSSCell area='header'>{enterpriseImage}</DiverstCSSCell>
        <DiverstCSSCell area='message'>{enterpriseMessage}</DiverstCSSCell>
        <DiverstCSSCell area='content'>{content}</DiverstCSSCell>
        <DiverstCSSCell area='sponsor'>{sponsor}</DiverstCSSCell>
        <DiverstCSSCell area='privacy'>{privacyMessage}</DiverstCSSCell>
      </DiverstCSSGrid>
    );
  }
}

const mapDispatchToProps = {
};

const mapStateToProps = createStructuredSelector({
  sponsorTotal: selectSponsorTotal(),
  enterprise: selectEnterprise(),
  permissions: selectPermissions()
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

HomePage.propTypes = {
  classes: PropTypes.object,
  enterprise: PropTypes.object,
  intl: intlShape.isRequired,
  sponsorTotal: PropTypes.number,
  permissions: PropTypes.object
};

export default compose(
  withConnect,
  memo,
  injectIntl,
  withStyles(styles),
)(HomePage);

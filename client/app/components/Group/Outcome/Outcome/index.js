import React, { memo } from 'react';

import { compose } from 'redux';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Typography, Card, CardContent, Divider, Link, CardActionArea, Box, Grid
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Group/Outcome/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

import DiverstShowLoader from 'components/Shared/DiverstShowLoader';
import { ROUTES } from 'containers/Shared/Routes/constants';

import OutcomeEventListItem from 'components/Event/OutcomeEventListItem';

const styles = theme => ({
  title: {
    fontWeight: 'bold',
    paddingBottom: theme.spacing(3),
  },
  card: {
    marginBottom: 32,
  },
  eventLink: {
    textDecoration: 'none !important',
  },
  eventListItemSpacer: {
    backgroundColor: theme.palette.primary.main50,
    width: 10,
  },
  divider: {
    height: 2,
  },
});

export function Outcome(props) {
  const { classes } = props;
  const outcome = dig(props, 'outcome');

  return (
    <DiverstShowLoader isLoading={props.isFormLoading} isError={!props.isFormLoading && !outcome}>
      {outcome && (
        <React.Fragment>
          <Typography color='primary' variant='h5' component='h2' className={classes.title}>
            {outcome.name}
          </Typography>
          {outcome.pillars && outcome.pillars.length > 0 && outcome.pillars.map(pillar => (
            <Card key={pillar.id} className={classes.card}>
              <CardContent>
                <Typography variant='h6'>
                  {pillar.name}
                </Typography>
              </CardContent>
              {pillar.initiatives && pillar.initiatives.length > 0 && pillar.initiatives.map(initiative => (
                <React.Fragment key={initiative.id}>
                  <Divider className={classes.divider} />
                  <Link
                    className={classes.eventLink}
                    component={WrappedNavLink}
                    to={ROUTES.user.home.path()}
                  >
                    <CardActionArea>
                      <Grid container>
                        <Grid item className={classes.eventListItemSpacer} />
                        <Grid item xs>
                          <CardContent>
                            <OutcomeEventListItem item={initiative} />
                            <Box mb={1} />
                          </CardContent>
                        </Grid>
                      </Grid>
                    </CardActionArea>
                  </Link>
                </React.Fragment>
              ))}
            </Card>
          ))}
        </React.Fragment>
      )}
    </DiverstShowLoader>
  );
}

Outcome.propTypes = {
  classes: PropTypes.object,
  outcome: PropTypes.object,
  currentUserId: PropTypes.number,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    outcomeEdit: PropTypes.string,
  })
};

export default compose(
  memo,
  withStyles(styles),
)(Outcome);

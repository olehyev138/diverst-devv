/**
 *
 * Group Member List Component
 *
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import {
  Button, Box, MenuItem, Grid, Typography, Card, CardContent, CardActions
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import { injectIntl, intlShape } from 'react-intl';
import { useFormik, Field, Formik, Form } from 'formik';
import { DiverstDatePicker } from 'components/Shared/Pickers/DiverstDatePicker';
import { DateTime } from 'luxon';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import SegmentSelector from 'components/Shared/SegmentSelector';
import messages from 'containers/Group/GroupMembers/messages';

import DeleteIcon from '@material-ui/icons/DeleteOutline';
import AddIcon from '@material-ui/icons/Add';
import ExportIcon from '@material-ui/icons/SaveAlt';

import DiverstTable from 'components/Shared/DiverstTable';
import DiverstDropdownMenu from 'components/Shared/DiverstDropdownMenu';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';
const styles = theme => ({
  errorButton: {
    color: theme.palette.error.main,
  },
  actionButton: {
    marginRight: 12,
    marginBottom: 12,
  },
  submitButton: {
    marginLeft: 12,
    marginBottom: 12,
  },
  staticWidthButton: {
    width: '100%',
    marginLeft: 12,
    marginRight: 12,
  },
  menuItem: {
    width: '300',
  },
  floatRight: {
    float: 'right',
    marginBottom: 12,
  },
  floatLeft: {
    float: 'left',
    marginBottom: 12,
  },
  halfWidth: {
    width: '400',
  },
  dateTime: {
    width: '50%'
  },
  floatSpacer: {
    display: 'flex',
    width: '100%',
    marginBottom: 12,
  },
});

export function GroupMemberList(props) {
  const { classes, intl } = props;

  // MENU CODE
  const [anchor, setAnchor] = React.useState(null);

  const handleClick = (event) => {
    setAnchor(event.currentTarget);
  };

  const handleClose = (type) => {
    setAnchor(null);
    props.handleChangeTab(type);
  };

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'users.id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const columns = [
    {
      title: <DiverstFormattedMessage {...messages.columns.givenName} />,
      field: 'user.first_name',
      query_field: 'users.first_name'
    },
    {
      title: <DiverstFormattedMessage {...messages.columns.familyName} />,
      field: 'user.last_name',
      query_field: 'users.last_name'
    },
    {
      title: <DiverstFormattedMessage {...messages.columns.status} />,
      field: 'status',
      query_field: '(CASE WHEN users.active = false THEN 3 WHEN groups.pending_users AND NOT accepted_member THEN 2 ELSE 1 END)',
      sorting: true,
      lookup: {
        active: intl.formatMessage(messages.status.active),
        inactive: intl.formatMessage(messages.status.inactive),
        pending: intl.formatMessage(messages.status.pending),
      }
    },
  ];

  const actions = [];

  if (permission(props.currentGroup, 'members_destroy?'))
    actions.push(
      {
        icon: () => <DeleteIcon />,
        tooltip: intl.formatMessage(messages.tooltip.delete),
        onClick: (_, rowData) => {
          /* eslint-disable-next-line no-alert, no-restricted-globals */
          if (confirm(intl.formatMessage(messages.tooltip.delete_confirm)))
            props.deleteMemberBegin({
              userId: rowData.id,
              groupId: props.groupId
            });
        }
      }
    );

  return (
    <React.Fragment>
      <Box className={classes.floatRight}>
        <Permission show={permission(props.currentGroup, 'members_create?')}>
          <Button
            className={classes.actionButton}
            variant='contained'
            to={props.links.groupMembersNew}
            color='primary'
            size='large'
            component={WrappedNavLink}
            startIcon={<AddIcon />}
          >
            <DiverstFormattedMessage {...messages.new} />
          </Button>
        </Permission>
        <Button
          className={classes.actionButton}
          variant='contained'
          color='secondary'
          size='large'
          startIcon={<ExportIcon />}
          onClick={() => props.exportMembersBegin()}
        >
          <DiverstFormattedMessage {...messages.export} />
        </Button>
      </Box>

      <Box className={classes.floatSpacer} />

      <Grid container spacing={1} alignItems='flex-end'>
        <Grid item md={4} container alignItems='stretch'>
          <Card>
            <CardContent>
              <Grid
                container
                justify='space-between'
                spacing={3}
                alignContent='stretch'
                alignItems='center'
              >
                <Grid item md='auto'>
                  <Typography align='left' variant='h6' component='h2' color='primary'>
                    <DiverstFormattedMessage {...messages.changeScope} />
                  </Typography>
                </Grid>
                <Grid item md='auto'>
                  <Button
                    variant='contained'
                    color='secondary'
                    size='large'
                    onClick={handleClick}
                  >
                    <DiverstFormattedMessage {...messages.scopes[props.memberType]} />
                  </Button>
                </Grid>
              </Grid>
            </CardContent>
          </Card>
        </Grid>
        <Grid item md={8}>
          <Card>
            <Formik
              initialValues={{
                from: props.memberFrom,
                to: props.memberTo,
                segmentLabels: props.segmentLabels,
              }}
              enableReinitialize
              onSubmit={(values) => {
                values.segmentIds = (values.segmentLabels || []).map(i => i.value);
                props.handleFilterChange(values);
              }}
            >
              {formikProps => (
                <Form>
                  <CardContent>
                    <Grid container spacing={2}>
                      <Grid item xs={6}>
                        <Field
                          component={DiverstDatePicker}
                          keyboardMode
                          fullWidth
                          maxDate={formikProps.values.to ? formikProps.values.to : new Date()}
                          maxDateMessage={<DiverstFormattedMessage {...messages.filter.fromMax} />}
                          id='from'
                          name='from'
                          margin='normal'
                          label={<DiverstFormattedMessage {...messages.filter.from} />}
                        />
                      </Grid>
                      <Grid item xs={6}>
                        <Field
                          component={DiverstDatePicker}
                          keyboardMode
                          fullWidth
                          minDate={formikProps.values.from ? formikProps.values.from : undefined}
                          maxDate={new Date()}
                          minDateMessage={<DiverstFormattedMessage {...messages.filter.toMin} />}
                          maxDateMessage={<DiverstFormattedMessage {...messages.filter.toMax} />}
                          id='to'
                          name='to'
                          margin='normal'
                          label={<DiverstFormattedMessage {...messages.filter.to} />}
                        />
                      </Grid>
                    </Grid>
                    <SegmentSelector
                      segmentField='segmentLabels'
                      label={<DiverstFormattedMessage {...messages.filter.segments} />}
                      {...formikProps}
                    />
                  </CardContent>
                  <CardActions>
                    <Button
                      color='primary'
                      type='submit'
                      variant='contained'
                      className={classes.submitButton}
                    >
                      <DiverstFormattedMessage {...messages.filter.submit} />
                    </Button>
                  </CardActions>
                </Form>
              )}
            </Formik>
          </Card>
        </Grid>
      </Grid>

      <Box className={classes.floatSpacer} />

      <DiverstTable
        title={intl.formatMessage(messages.members)}
        handlePagination={props.handlePagination}
        isLoading={props.isFetchingMembers}
        onOrderChange={handleOrderChange}
        dataArray={props.memberList}
        dataTotal={props.memberTotal}
        columns={columns}
        rowsPerPage={props.params.count}
        actions={actions}
        my_options={{
          exportButton: true,
          exportCsv: (columns, data) => {
            props.exportMembersBegin();
          }
        }}
      />
      <DiverstDropdownMenu
        anchor={anchor}
        setAnchor={setAnchor}
      >
        <MenuItem
          onClick={() => handleClose('accepted_users')}
          className={classes.menuItem}
        >
          <DiverstFormattedMessage {...messages.scopes.accepted_users} />
        </MenuItem>
        <MenuItem
          onClick={() => handleClose('inactive')}
          className={classes.menuItem}
        >
          <DiverstFormattedMessage {...messages.scopes.inactive} />
        </MenuItem>
        <MenuItem
          onClick={() => handleClose('pending')}
          className={classes.menuItem}
        >
          <DiverstFormattedMessage {...messages.scopes.pending} />
        </MenuItem>
        <MenuItem
          onClick={() => handleClose('all')}
          className={classes.menuItem}
        >
          <DiverstFormattedMessage {...messages.scopes.all} />
        </MenuItem>
      </DiverstDropdownMenu>
    </React.Fragment>
  );
}

GroupMemberList.propTypes = {
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  deleteMemberBegin: PropTypes.func,
  exportMembersBegin: PropTypes.func,
  links: PropTypes.shape({
    groupMembersNew: PropTypes.string,
  }),
  params: PropTypes.object,
  memberList: PropTypes.array,
  memberTotal: PropTypes.number,
  isFetchingMembers: PropTypes.bool,
  groupId: PropTypes.string,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,

  memberType: PropTypes.string.isRequired,
  MemberTypes: PropTypes.array.isRequired,
  handleChangeTab: PropTypes.func.isRequired,

  memberFrom: PropTypes.instanceOf(DateTime),
  memberTo: PropTypes.instanceOf(DateTime),
  segmentLabels: PropTypes.array,
  handleFilterChange: PropTypes.func.isRequired,
  currentGroup: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
  injectIntl,
)(GroupMemberList);

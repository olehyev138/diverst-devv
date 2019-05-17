/*
 * LoginPage
 *
 * This is the first thing users see of our App, at the "/login" route
 */

import React from "react";
import PropTypes from "prop-types";
import { FormattedMessage } from "react-intl";
import { connect } from "react-redux";
import { compose } from "redux";
import { createStructuredSelector } from "reselect";

import Button from "@material-ui/core/Button";
import Card from "@material-ui/core/Card";
import CardActions from "@material-ui/core/CardActions";
import CardContent from "@material-ui/core/CardContent";
import Grid from "@material-ui/core/Grid";
import TextField from "@material-ui/core/TextField";

import Container from "react-bootstrap/Container";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";

import injectReducer from "utils/injectReducer";
import injectSaga from "utils/injectSaga";
import LocaleToggle from "containers/LocaleToggle";
import Logo from "components/Logo";
import messages from "./messages";
import reducer from "./reducer";
import saga from "./saga";
import { handleSubmit, handleFindCompany } from "./actions";
import { makeSelectEnterprise } from "./selectors";
import { makeSelectPrimary } from "containers/ThemeProvider/selectors";

import "./index.css"; // Tell Webpack that Button.js uses these styles

/* eslint-disable react/prefer-stateless-function */
export class LoginPage extends React.PureComponent {

    constructor(props) {
        super(props);
        this.handleChange = this.handleChange.bind(this);
        this.onSubmit = this.onSubmit.bind(this);
        this.onFindCompany = this.onFindCompany.bind(this);
        this.state = {
            email: "",
            password: ""
        };
    }

    handleChange(e) {
        const { name, value } = e.target;
        this.setState({
            [name]: value
        });
    }
    
    onFindCompany(){
        const {email} = this.state;
        this.props.handleFindCompany({email});
    }

    onSubmit() {
        const { email, password } = this.state;
        this.props.handleSubmit({ email, password });
    }

    /**
     * when initial state email is not null, submit the form to load repos
     */
    componentDidMount() {
    }

    componentWillUnmount() {
    }

    render() {
        return (
            <Grid container className="total-center" justify="center">
                <Grid item lg={4} md={6} sm={8} xs={12}>
                    <Card>
                        <Container>
                            <Row className="justify-content-md-center padded logo">
                                <Col xs={{ span: 6, offset: 3 }}>
                                    <Logo/>
                                </Col>
                            </Row>
                        </Container>
                        <form>
                            <CardContent>
                                <TextField
                                    autoFocus
                                    fullWidth
                                    disabled={false}
                                    id="email"
                                    name="email"
                                    defaultValue={this.state.email}
                                    onChange={this.handleChange}
                                    label={<FormattedMessage {...messages.email} />}
                                    margin="normal"
                                    type="email"
                                    autoComplete="off"
                                />
                                { this.props.enterprise ?
                                    <TextField
                                        fullWidth
                                        disabled={false}
                                        id="password"
                                        name="password"
    									defaultValue={this.state.password}
                                        onChange={this.handleChange}
                                        label={<FormattedMessage {...messages.password} />}
                                        margin="normal"
                                        type="password"
                                        autoComplete="off"
                                    />
                                    : <div/>
                                }
                            </CardContent>
                            { this.props.enterprise ?
                                <CardActions>
                                    <Grid container>
                                        <Grid item align="left" xs={4}>
                                            <Button
                                                className="submit-button"
                                                color="primary"
                                                disabled={!this.state.email || !this.state.password}
                                                size="small"
                                                onClick={this.onSubmit}
    										>
    											{<FormattedMessage {...messages.login} />}
                                            </Button>
                                        </Grid>
                                        <Grid item align="right" xs={4}>
                                            <Button
                                                className="submit-button"
                                                color="primary"
                                                disabled={!!this.state.email || !!this.state.password}
                                                size="small"
    										>
    											{<FormattedMessage {...messages.forgotPassword} />}
                                            </Button>
                                        </Grid>
                                        <Grid item align="right" xs={4}>
                                            <Button
                                                className="submit-button"
                                                color="primary"
                                                disabled={!!this.state.email || !!this.state.password}
                                                size="small"
    										>
    											{<FormattedMessage {...messages.signup} />}
                                            </Button>
                                        </Grid>
                                    </Grid>
                                </CardActions>
                                : <CardActions>
                                    <Grid container>
                                        <Grid item align="center" xs={12}>
                                            <Button
                                                className="submit-button"
                                                color="primary"
                                                disabled={!this.state.email}
                                                size="small"
                                                onClick={this.onFindCompany}
    										>
    											{<FormattedMessage {...messages.findCompany} />}
                                            </Button>
                                        </Grid>
                                    </Grid>
                                </CardActions>
                            }
                        </form>
                        <LocaleToggle />
                    </Card>
                </Grid>
            </Grid>
        );
    }
}

LoginPage.propTypes = {
    handleSubmit: PropTypes.func,
    email: PropTypes.string,
    password: PropTypes.string,
};

export function mapDispatchToProps(dispatch, ownProps) {
    return {
        handleSubmit: function(payload) {
            dispatch(handleSubmit(payload));
        },
        handleFindCompany: function(payload){
            dispatch(handleFindCompany(payload));
        }
    };
}

const mapStateToProps = createStructuredSelector({
    enterprise: makeSelectEnterprise(),
    primaryColor: makeSelectPrimary()
});

const withConnect = connect(
    mapStateToProps,
    mapDispatchToProps,
);

const withReducer = injectReducer({ key: "login", reducer });
const withSaga = injectSaga({ key: "login", saga });

export default compose(
    withReducer,
    withSaga,
    withConnect,
)(LoginPage);
